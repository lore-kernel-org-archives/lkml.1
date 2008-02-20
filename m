Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbYBTWjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbYBTWjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYBTWjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:39:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:29994 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYBTWjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dLUgF4gf+UfqjT0lFjSlXxK9JCzrdD+6P3/+modIvn1x29l9zFaEXbUmKEMtZ2OpiwlB03fbj+l3nCdAPGQW/CAbMqdABfFVgGiAkk17chGzIDRaVhj2t3NTb5fR/yV8o0fYHEcupHp82pikDoPb5+jEqtZNrO5nTpqTXmqtclc=
Subject: Re: sparse - make __CHECK_ENDIAN__ default enabled?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080220220326.GA22328@uranus.ravnborg.org>
References: <20080220220326.GA22328@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 14:39:46 -0800
Message-Id: <1203547186.25307.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 23:03 +0100, Sam Ravnborg wrote:
> Hi Harvey.
> 
> Can I ask you to look into the worst offenders so we
> can make -D__CHECK_ENDIAN__ enabled per default
> in the kernel.
> Or maybe we should do it anyway?

>From a quick test, the same places that spew sparse warnings, spew
lots more sparse warnings, the places that are not so bad....are not
so bad afterwards either.

There's still so many of the trivial warnings that maybe it's not the
right time for this yet.  Ask me again when we get to the 2.6.26
timeframe, we'll see how many I've gotten rid of by then.

Harvey


