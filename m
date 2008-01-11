Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYAKLuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYAKLuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYAKLuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:50:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:17246 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYAKLui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XbnwoRAUER7O8JFx9BDTQjhGZptbFGOByZJ9nIF6N0qOFkNbyo0TBg7Lshqk/OAmw+CPfhC/WRk22QC+NWfH/RTuf6LFayaRq2Kpp7WlfnjwaS4se7dh/f4yHlbEj26hv4k2MVI5/YC0CTJZGhHiSm/1yEG/chNcGEVXMUdQH3E=
Message-ID: <47875809.7060301@gmail.com>
Date: Fri, 11 Jan 2008 12:50:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Daniel Walker <dwalker@mvista.com>, Bernd Petrovitsch <bernd@firmix.at>,
       apw@shadowen.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com> <1200044206.29897.73.camel@imap.mvista.com> <4787502B.2020606@s5r6.in-berlin.de>
In-Reply-To: <4787502B.2020606@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2008 12:16 PM, Stefan Richter wrote:
> Daniel Walker wrote:
>> On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
>>>>> On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
>>>>>> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
>>>>> | ./scripts/checkpatch.pl -
> 
>>> If somebody is hacking kernel, I think he should know the - trick used in many 
>>> programs, but do not consider this as a nack.
>> I'm hacking the kernel, and I didn't know the - trick .. So you have
>> your testing case all in one with the patch submitter ..
> 
> How about
> 
>  if ($#ARGV < 0) {
>  	print "usage: $P [options] patchfile\n";
>  	print "version: $V\n";
>  	print "options: -q           => quiet\n";
>  	print "         --no-tree    => run without a kernel tree\n";
>  	print "         --terse      => one line per report\n";
>  	print "         --emacs      => emacs compile window format\n";
>  	print "         --file       => check a source file\n";
>  	print "         --strict     => enable more subjective tests\n";
>  	print "         --root       => path to the kernel tree root\n";
> +	print "When patchfile is -, read standard input.\n";
>  	exit(1);
>  }
> 

My ACK.

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
