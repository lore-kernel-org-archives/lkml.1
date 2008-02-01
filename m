Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYBALWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYBALWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYBALWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:22:13 -0500
Received: from hu-out-0506.google.com ([72.14.214.227]:18957 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYBALWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pSXn2t95U3wquS6DY5Jnbi5GWX3q3F8PYuM4MDo+OjIUamMLKsNKqGNOeJBAF/BhtCULMg0kampmGDfcA30KKpCAEN2Mx8xxjLZ30GYEYYwePcu0jZXPsPPLfSW+YkukVcPvBMLEmA7T53v5bqgtqY4deR6cu/Kcx2aNDGaAjQ4=
Subject: Re: Are Section mismatches out of control?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20080201030329.9b760777.akpm@linux-foundation.org>
References: <20080201104718.GA11717@uranus.ravnborg.org>
	 <20080201030329.9b760777.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 03:21:34 -0800
Message-Id: <1201864894.23523.117.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 03:03 -0800, Andrew Morton wrote:
> On Fri, 1 Feb 2008 11:47:18 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > James said in a related posting that the Section mismatch
> > warnings were getting out of control.
> 
> eh.  They're easy - the build system tells you about them!
> 
> > The list is here:
> 
> Question is: why do people keep adding new ones when they are so easy to
> detect and fix?
> 
> Asnwer: because neither they nor their patch integrators are doing adequate
> compilation testing.

Because if there already exists more than a handful peoples' eyes glaze
over and ignore "just one more warning"

Unless they break the build, or if there currently are 0 and they make
it non-zero, people seem not to care....sad.  Probably the same for
sparse/checkpatch, "there's plenty already, I can't be bothered to look"

Subject to someone _making_ it an issue, can't see it changing.

Harvey

