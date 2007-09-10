Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbXIJSib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbXIJSib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 14:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXIJSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 14:38:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbXIJSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 14:38:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hJg+ou2MPl+MuvG7CGhIIkp9qS7jO75d1lF5Vw67BhlXmTYv4w6W4m42xAFxvmt/H
	4BVqaBFRmdmWXJlJnjWDA==
Message-ID: <6599ad830709101138q7528eba7ia4fb618b8fe158cc@mail.gmail.com>
Date: Mon, 10 Sep 2007 11:38:10 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [Devel] Re: [PATCH] Hookup group-scheduler with task container infrastructure
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, containers@lists.osdl.org,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ckrm-tech@lists.sourceforge.net
In-Reply-To: <20070910172334.GB19100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910171049.GA16048@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0709101903220.5368@fbirervta.pbzchgretzou.qr>
	 <20070910172334.GB19100@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
> Unless folks have strong objection to it, I prefer "cptctlr", the way it is.
>

By definition any container (about to be renamed control group)
subsystem is some kind of "controller" so that bit seems a bit
redundant.

Any reason not to just call it "cpu" or "cpu_sched"

Paul
