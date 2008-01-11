Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYAKLSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYAKLSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYAKLSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:18:05 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48237 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbYAKLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:18:04 -0500
Message-ID: <4787502B.2020606@s5r6.in-berlin.de>
Date: Fri, 11 Jan 2008 12:16:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Bernd Petrovitsch <bernd@firmix.at>,
       apw@shadowen.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch.pl: allow piping
References: <20080111041120.085610726@mvista.com>	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com> <1200044206.29897.73.camel@imap.mvista.com>
In-Reply-To: <1200044206.29897.73.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
>> >> On Fre, 2008-01-11 at 10:21 +0100, Jiri Slaby wrote:
>> >>> git show 9914cad54c79d0b89b1f066c0894f00e1344131c
>> >> | ./scripts/checkpatch.pl -

>> If somebody is hacking kernel, I think he should know the - trick used in many 
>> programs, but do not consider this as a nack.
> 
> I'm hacking the kernel, and I didn't know the - trick .. So you have
> your testing case all in one with the patch submitter ..

How about

 if ($#ARGV < 0) {
 	print "usage: $P [options] patchfile\n";
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
 	print "         --terse      => one line per report\n";
 	print "         --emacs      => emacs compile window format\n";
 	print "         --file       => check a source file\n";
 	print "         --strict     => enable more subjective tests\n";
 	print "         --root       => path to the kernel tree root\n";
+	print "When patchfile is -, read standard input.\n";
 	exit(1);
 }

-- 
Stefan Richter
-=====-==--- ---= -=-==
http://arcgraph.de/sr/
