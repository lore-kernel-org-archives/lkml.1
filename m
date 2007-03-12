Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbXCLUMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbXCLUMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXCLUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:12:37 -0400
Received: from drugphish.ch ([69.55.226.176]:48701 "EHLO www.drugphish.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXCLUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:12:36 -0400
X-Greylist: delayed 1689 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 16:12:36 EDT
Message-ID: <45F5AD8E.2080105@drugphish.ch>
Date: Mon, 12 Mar 2007 20:44:14 +0100
From: Roberto Nibali <ratz@drugphish.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Valdis.Kletnieks@vt.edu, "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MPT FUSION: Delete unused header files.
References: <664A4EBB07F29743873A87CF62C26D70623ED6@NAMAIL4.ad.lsil.com>
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70623ED6@NAMAIL4.ad.lsil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Certainly appropriate content for something on your website, 
>> and vendors who
>> provide programs like dmidecode and parsemce are always 
>> welcome. I could
>> probably be convinced that such info should have at least a 
>> pointer somewhere
>> in Documentation/lsi_debug.txt or some such.  But quite 
>> frankly, if I'm reduced
>> to wading through *.h files to figure out what some 
>> recalcitrant hardware is
>> upset about, there's been a failure in documentation.  
>> *ESPECIALLY* if I
>> go look at drivers/whatever/source.c and it doesn't even 
>> *reference* the *.h
>> file in question.
> 
> 
> Its apparent to me that you don't have our hardware, nor have you
> actually waded thru this driver source code. 

Allow me to shortly chime in here:

I'm the author of the mpt-status user space tool (a simple alternative 
to your Java GUI tool), which queries LSI controllers and reports back 
the RAID status and the synchronization state; so I have waded through 
the driver source code quite a lot. My question:

> If you did, you would of noticed that the header you want to delete, is
> actually referenced in the *.c source code.   The file "mpi_log_fc.h",
> is indeed mentioned in mptbase.c, in the function called
> mpt_fc_log_info, in the documention section above the function.    This
> header file is very helpful to those supporting our hardware, and those
> using it
> For SAS(mpi_log_sas.h), I have broken out each loginfo in the strings
> you will find defined in originator_str, iop_code_str, pl_code_str, etc,
> I probably do that with fibre.
> 
> If its that important to you to have the header files included, I will
> provide a patch that does that.    

I would really like to see "sanitized" kernel headers, so is it possible 
to have your headers inside ../drivers/message/fusion{,/lsi} somehow 
inserted into the process of the headers_install target?

Best regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
