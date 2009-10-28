Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZJ1LnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZJ1LnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZJ1LnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:43:01 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57248 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZJ1LnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LuMYX5X4V1nB6DKqI388gFcJuwWJt4MCUeP/3WrPNllDEtMdRTGYjnqSUtQt6ppeiw
         AQgk5P9T/7lhJbO0cOPj+izONnlQv0sIwns7JEQu8PaZGlOqS7+p+3JkaUWx5r6k6Djb
         mwXZ9metdhO0F0JJ1sjtEyjn3N/moatb0nBFk=
Message-ID: <4AE82DF9.6050506@ring3k.org>
Date: Wed, 28 Oct 2009 20:41:45 +0900
From: Mike McCormack <mikem@ring3k.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: bart.hartgers@gmail.com
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ark3116: (v2) driver rework after review
References: <20091028094324.010816897@gmail.com>
In-Reply-To: <20091028094324.010816897@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bart.hartgers@gmail.com wrote:
> Hi Greg,
> 
> I updated my ark3116 patches after the review on the list. The main
> change is the removal of the atomic_t fields and addition of a spinlock.
> 
> This patch set brings the ark3116 driver up to date by:
> - replacing the magic numbers by proper uart register accesses
> - introducing locking
> - line error handling
> - interrupt based modem status handling
> - cts/rts handshaking
> - break signaling
> 
> The patches are against 2.6.32-rc4.
> 
> Mike: do you still want to combine these with yours?: if so, let me
> know if I can help with merging them.

Hey Guys,

If everybody is happy with this patch set, then go ahead with it.  I was going
to try to clean up the old code first before adding new stuff, however it
won't be necessary if these patches are applied.

When all the dust settles, I'm happy to clean up anything left over :-)

thanks,

Mike

