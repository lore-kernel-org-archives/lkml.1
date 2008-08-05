Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbYHEXL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbYHEXL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbYHEXLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:11:49 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:9964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbYHEXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vlFAxkgeqHLAlOqFdwsl7GJEjsWBH+GE2f6Ulgtvmb9HsZDygXNhVHn7FCMxTwjFOS
         fA3OCE6kI9baNe832bHdgNqW/r4Zh30LrQBUomQO90udGztIgf2Zzayk3mY5V8MDsUqI
         KXfixN/0+U4jnwUN/iOy9vqYmMeImPZAcmbV4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.27-rc1: keyboard/mouse gone after s2ram
Date: Tue, 5 Aug 2008 19:11:45 -0400
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jikos@suse.cz
References: <20080805211911.GA1574@elf.ucw.cz>
In-Reply-To: <20080805211911.GA1574@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051911.45873.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008, Pavel Machek wrote:
> ...on thinkpad x60. I can still use power button to shut the machine
> down.
> 
> s2disk works okay.
> 
> 									Pavel

Does it help if you revert 6aabcdffd1a5f8f5b906696e58069c4f8fced542?
Can I get a log with i8042.debug please?

-- 
Dmitry
