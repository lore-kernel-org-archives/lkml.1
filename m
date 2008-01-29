Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbYA2Sb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbYA2Sb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYA2SbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:31:20 -0500
Received: from gw.goop.org ([64.81.55.164]:40015 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYA2SbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:31:19 -0500
Message-ID: <479F70E9.40905@goop.org>
Date: Tue, 29 Jan 2008 10:31:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>	 <479E5D22.1070109@goop.org> <1201599251.5301.26.camel@localhost.localdomain> <479F6845.1070902@goop.org> <479F6AD2.8050908@zytor.com>
In-Reply-To: <479F6AD2.8050908@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> It's also easy enough to either use objdump -h or nm to extract info 
> from vmlinux; or for some of the simpler stuff, just parse the ELF 
> directly (perhaps using libelf).
>
> There is also the -R option to ld, which imports symbols from one 
> executable into another. 

Yes, I used -R, though it was necessary to generate a copy of vmlinux 
with a filtered symbol list to prevent collisions.  But I'm not sure any 
of this is necessary with Ian's approach.

    J

