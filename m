Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYA2SJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYA2SJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764711AbYA2SIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:08:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:28241 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764140AbYA2SIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XiurbGoodIhMfduAcIaMHb97vvUzjokgCxF/w3MdtK2abFw7FM8lKwCA6Y51C+9M+yPIkkUKTpx38uip7PX59fTxuzTmEU6lWWMw2tTS3llS2AKhhLpeDVJBipUElhzWwuQamgHrYWYeXbc0qWSOuMBdFAJauFGhq5CYNTsS4lE=
Message-ID: <863e9df20801291008x40208609j15749fc6e39fbe47@mail.gmail.com>
Date: Tue, 29 Jan 2008 23:38:31 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Cc: ananth@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       jkenisto@us.ibm.com, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <479F4291.1060106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com>
	 <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
	 <479F4291.1060106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> In that case, why don't you just reduce the priority of kprobe_exceptions_nb?
> Then, the execution path becomes very simple.

Ananth mentioned that the kprobe notifier has to be the first to run.
It still wouldnt allow us to notice breakpoints on places like do_int3
etc.

> I also like to use a debugger for debugging kprobes. that will help us.

Hmm...It would increase the code-path leading upto kprobe_handler.
That's more territory to be guarded from kprobes.

> Best Regards,
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
--
Thanks,
Abhishek
