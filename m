Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbZIYIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbZIYIQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZIYIQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:16:19 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57433 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZIYIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QueUb55dVmcslQ+VhR8yuArR2TSpXMrav6/9x+Vo2pUeLtk5B4s/JuyeRXU61vApVj
         XxEHUKmvSLb5PCKuc4PTtqGWE2hg/QRrObs3jm1w0cFZwrkh/LZodIORD2lv4F+8zCVW
         zKb26PIOE7StlIJnb9Lip+OEv3ZbbIewslb2Q=
Date: Fri, 25 Sep 2009 10:16:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 4/5 v2] tracing/filters: Provide basic regex support
Message-ID: <20090925081614.GA4686@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <1253821775-8618-5-git-send-email-fweisbec@gmail.com> <20090925081345.GA9236@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925081345.GA9236@centrinvest.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:13:45PM +0400, Andrey Panin wrote:
> On 267, 09 24, 2009 at 09:49:34PM +0200, Frederic Weisbecker wrote:
> > This patch provides basic support for regular expressions in filters.
> 
> > +/* Basic regex callbacks */
> > +static int regex_match_full(char *str, struct regex *r, int len)
> > +{
> > +	if (strncmp(str, r->pattern, len) == 0)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static int regex_match_front(char *str, struct regex *r, int len)
> > +{
> > +	if (strncmp(str, r->pattern, len) == 0)
> > +		return 1;
> > +	return 0;
> > +}
> 
> These two functions are identical, what's the reason to keep them separate ?
> And why not simply return strncmp(str, r->pattern, len) == 0 ?


Good catch! I'll fix that, thanks.

