Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbYJJVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbYJJVi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763072AbYJJVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:38:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:32752 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764627AbYJJVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=AokKatyVcbNjOE3kagB59xUhh4cB8XdtZW+/wYe6bmGQxNbTY/4g1e6c8Q9zEbFCso
         xVlatIyEG4EmJ5Zhwn4bLMzefXnDOQ4Uw7SL+nyNIUXAlzptOh7XoUi68DEkvbQs6RB6
         rUWBbzOeZYbQfdO4bwZDT4dpKglyh2Ln9n438=
Message-ID: <48EFCB5C.6090303@gmail.com>
Date: Fri, 10 Oct 2008 22:38:36 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080810)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] orinoco: fix unsafe locking in orinoco_cs_resume
References: <200810102022.40027.arvidjaar@mail.ru>
In-Reply-To: <200810102022.40027.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dave <kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Attached patch should fixe lockdep warning. Unfortunately it is rather
> hard to trigger on purpose.

ACK.

Looks like spectrum_cs has the same problem with suspend. I'll submit a patch for that.



Dave.
