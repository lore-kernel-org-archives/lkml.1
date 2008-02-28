Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYB1RqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYB1RqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYB1Rpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:45:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:46583 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbYB1Rpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:45:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GOWYjRTqm2UOpCjw9Ew6lYf/RfkJT8fT5ethSr6qX08T2oennnpv8had+DETtEvfGuPedJmpJX5MXqaJ79ASbUH8OtQE0XKPTXJhTPWMKZxcOx3qEnT8nxCCEPmxDReLtlJUuYPC7Q3ijZ1kw+t4UrLe2ttP/ZC6ZE0q/ooB+u4=
Message-ID: <86802c440802280945w4dd71038y95936656cd535c9c@mail.gmail.com>
Date: Thu, 28 Feb 2008 09:45:52 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Cc: "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "Christoph Lameter" <clameter@sgi.com>,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <20080228154244.GA4038@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	 <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie>
	 <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie>
	 <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com>
	 <20080219192319.GE12386@csn.ul.ie>
	 <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com>
	 <20080228154244.GA4038@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 7:42 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (26/02/08 22:29), Yinghai Lu didst pronounce:
>
> > >  >
>  > >  > Did you get a chance to try out this patch to see if it cleared up the problem
>  > >  > booting on your x86_64 numa box?
>  >
>  > did it fail with x86.git#testing?
>  >
>
>  No, it boots successfully with that git branch. Somewhere in there is a fix.
>

can you verify which one fix that ?

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=a8de04ce4e4cf0af94aeb3829be8c9f813b2f5de
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=96916d56dc6b500e39fd1855c3a6ce170b0fe28b
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commit;h=fa3dc9e2ad8a2aeb95a6ed3e6574cc09ab1c3115

YH
