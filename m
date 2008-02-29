Return-Path: <linux-kernel-owner+w=401wt.eu-S932524AbYB2OUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbYB2OUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYB2OUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:20:12 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:23834 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbYB2OUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MA9miGuLtk9ml/2DXxnPJjkOmEBJ2ti88oZJ7yce15wttp9qw7YxC7mFKXxg7QncsVP6hGElZWfRTTZ9NawuGwtQqFPd1XOC0Kt6LBwIuvDk6k+TKyQ+OVeqhmKRL9ml7chRsC2f33LhSk+7ieFt4N+xF2kT66Q1T/Th/44wVaU=
Message-ID: <ac8af0be0802290620q208cf4b0sd672cf18594074eb@mail.gmail.com>
Date: Fri, 29 Feb 2008 22:20:08 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: Can Linux kernel handle unsynced TSC?
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
In-Reply-To: <1204281823.6243.78.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0802290055m5ca1aa84yad6e38f6935f847@mail.gmail.com>
	 <1204281823.6243.78.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/29/08, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, 2008-02-29 at 16:55 +0800, Zhao Forrest wrote:
> > Sorry for reposting it.
> >
> > For example,
> > 1 rdtsc() is invoked on CPU0
> > 2 process is migrated to CPU1, and rdtsc() is invoked on CPU1
> > 3 if TSC on CPU1 is slower than TSC on CPU0, can kernel guarantee
> > that the second rdtsc() doesn't return a value smaller than the one
> > returned by the first rdtsc()?
>
> No, rdtsc() goes directly to the hardware. You need a (preferably cheap)
> clock abstraction layer on top if you need this.

Thank you for the clarification. I think gettimeofday() is such kind
of clock abstraction layer, am I right?
