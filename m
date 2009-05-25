Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZEYUBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZEYUBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEYUA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:00:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:41967 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZEYUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dxE2oI22Nt2W2AdAk/g6k6cfNnlCfpPYvZsXO4LgZ8JItTZcXbE8ULhiLFG85AKp/I
         KvTrQaodFDtB2Dvd9+6WxS36kIc8m77H5anF7Bl6wxu+Pvtbs9C+8a4ghhX+Dogf3rxc
         CadDAiEXxeVAHjVQMbhpcKf/ZA40qsHXBDtW0=
Date: Mon, 25 May 2009 22:00:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: rostedt@goodmis.org, mingo@elte.hu, tzanussi@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
	tracepoints
Message-ID: <20090525200050.GC7879@nowhere>
References: <20090520101334.GA23442@kryten> <c62985530905201701i36527eblae479c07eec06515@mail.gmail.com> <20090521123810.GB23442@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090521123810.GB23442@kryten>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 10:38:10PM +1000, Anton Blanchard wrote:
> 
> Hi Frédéric,
> 
> > > +       ),
> > > +
> > > +       TP_fast_assign(
> > > +               __entry->function = timer->function;
> > > +       ),
> > > +
> > > +       TP_printk("func=%pF", __entry->function)
> > 
> > 
> > Please use %pf which only prints the function name and ignore the
> > offsets and so... These overload
> > the trace in such case.
> 
> Thanks for the suggestion. It doesn't look like %pf has made Ingo's tree
> yet, do you know if there is a plan to merge it soon?
> 
> Anton


It's available on tip:master, may be you are working on another tree, or..?

