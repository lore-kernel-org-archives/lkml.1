Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYHTQjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYHTQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYHTQjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:39:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58980 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYHTQi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:38:59 -0400
Subject: Re: [discuss] memrlimit - potential applications that can use
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: righiandr@users.sourceforge.net
Cc: balbir@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
       Dave Hansen <haveblue@us.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Marco Sbrighi <m.sbrighi@cineca.it>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <a2776ec50808200625m5f6d9e6fs4d8e594bd259115a@mail.gmail.com>
References: <48AA73B5.7010302@linux.vnet.ibm.com>
	 <1219161525.23641.125.camel@nimitz>  <48AAF8C0.1010806@linux.vnet.ibm.com>
	 <1219167669.23641.156.camel@nimitz>
	 <a2776ec50808200625m5f6d9e6fs4d8e594bd259115a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 09:38:54 -0700
Message-Id: <1219250334.8960.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 15:25 +0200, righi.andrea@gmail.com wrote:
> Memory overcommit protection, instead, is a way to *prevent* OOM
> conditions (problem 1).

I completely disagree. :)

Think of all the work Eric Biederman did on pid namespaces.  One of his
motivations was to keep /proc from being able to pin task structs.  That
is one great example of a way a process can pin lots of memory without
mapping it, and overcommit has no effect on this!

Eric had a couple of other good examples, but I think task structs were
the biggest.

As I said to Balbir, there probably are some large-scale solutions to
this: things like beancounters.  

-- Dave

