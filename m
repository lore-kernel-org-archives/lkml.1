Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZFQPai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZFQPai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbZFQP3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:29:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54631 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbZFQP3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:29:49 -0400
Message-ID: <4A390C5C.9020606@redhat.com>
Date: Wed, 17 Jun 2009 11:31:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC][ PATCH -tip 0/6] kprobes: Kprobes jump optimization support
References: <20090612224925.17825.49637.stgit@localhost.localdomain> <alpine.DEB.1.10.0906131031570.29895@vinegar-pot.mit.edu> <4A381F8A.8020105@redhat.com>
In-Reply-To: <4A381F8A.8020105@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
>> udis86 generates all its instruction table data from an XML opcode file, 
>> which is I think what H. Peter Anvin was suggesting you should do in this 
>> previous thread on your instruction decoder: 
>> <http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/01929.html> 
>> Compared to e.g. libopcodes it is still quite small -- there's a total of 
>> about 3000 lines of C, plus some instruction tables that are automatically 
>> generated from an XML description of the instructions.
> 
> I'm not so sure about udis86. Can I use it in exception path (and kprobes)?
> Is that XML things enough easy to be maintained?

And one big question is that who needs full featured disassembler in kernel.
It seems that kprobes and other potential user only need an instruction
decoder (and an instruction emulator too.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

