Return-Path: <linux-kernel-owner+w=401wt.eu-S965346AbXBLTrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbXBLTrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965348AbXBLTrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:47:40 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46704 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965346AbXBLTrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:47:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <687898.45581.qm@web26907.mail.ukl.yahoo.com>
	<m17iuny2xg.fsf@ebiederm.dsl.xmission.com>
	<45D07457.9030006@zytor.com>
Date: Mon, 12 Feb 2007 12:47:27 -0700
In-Reply-To: <45D07457.9030006@zytor.com> (H. Peter Anvin's message of "Mon,
	12 Feb 2007 06:06:15 -0800")
Message-ID: <m1abzjw434.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> With ELF we get a single file format that works on multiple
>> architectures and for multiple OS-s, with well understood rules.  This
>> allows for a broader audience who can review and maintain the code.
>> In addition to the real possibility of multi-architecture or multi-os
>> bootloaders.
>>
>
> Well understood MAYBE (although the "virtual" versus "physical" address stuff in
> ELF is clearly misspecified in the extreme), but they are clearly not sufficient
> for presenting a well-defined entry condition. So it's not really anywhere near
> as straightforward as you make it sound.

About the entry condition I completely agree.

The fact that the generic tools almost do what you need and then fall short is
also problematic.

However it still appears a reasonable approach to consider.

Eric
