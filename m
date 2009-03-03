Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZCCTAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZCCTAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZCCTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:00:10 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:47077 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZCCTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tZxnMAMB/wcFO/Am0RepwPvg0ReyBrnVPkaZYzGpWN4y+nSE9ApeSVYtqhsEuE9qZV
         e+w09T5Rf2qGn6CKn7xXWdqLYq98pBRDQsHsEjs2sFUqRuZUUDbyZO80UMWVHyvHSPLT
         OPLVDWGqyA88ytd6LapHJrGuVV81pzfzFxBpU=
Message-ID: <49AD7E2B.3010101@gmail.com>
Date: Tue, 03 Mar 2009 18:59:55 +0000
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>, git@vger.kernel.org
CC: linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
References: <49A98F6A.50702@gmail.com> <1235886467.3195.15.camel@mj>
In-Reply-To: <1235886467.3195.15.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the git mailing list.

Pavel Roskin wrote:
> On Sat, 2009-02-28 at 19:24 +0000, Dave wrote:
>> I'm aware of at least a couple users of orinoco who have picked up
>> corrupt firmware# from the linux-firmware tree*.
>>
>> I've verified that the firmware in the repository itself is correct.
>>
>> It appears that downloading the file using the blob/raw links from
>> gitweb causes the corruption (0xc3 everywhere). At least it does with
>> firefox.
> 
> I can confirm the problem with Firefox 3.0.6.  But it's not "0xc3
> everywhere".  The corrupted file is a result of recoding from iso-8859-1
> to utf-8.  The correct agere_sta_fw.bin is 65046 bytes long.  The
> corrupted agere_sta_fw.bin is 89729 bytes long.
> 
> There is a way to recode the original binary with GNU recode:
> recode utf8..iso8859-1 agere_sta_fw.bin
> 
> wget 1.11.4 also gets a corrupted file 89729 bytes long.
> 
> curl 7.18.2 also get the corrupted file:
> 
> My strong impression is that the recoding takes place on the server.  I
> think the bug should be reported to the gitweb maintainers unless it a
> local breakage on the kernel.org site.

Thanks Pavel.

I just did a quick scan of the gitweb README - is this an issue with the
$mimetypes_file or $fallback_encoding configurations variables?


Regards,

Dave.

#<http://marc.info/?l=orinoco-users&m=123411762524637>
*<http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=shortlog>
