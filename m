Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJWN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJWN7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYJWN7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:59:01 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57955 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYJWN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=grp+atvqE9Vr7wWAGHbaSwpsjrGhRq4rX0D2j9R/logrGtJgdB2Q0uswcF6QGuVj9A
         XuZirwrKsRqWkKkyztal3XNXS9RVuL0U+CcxhsFBl0OO6LBMw3cTRuCXlz2qJu61w7d+
         cImBWKxFmMy2qCmoS5lobsWxuPHO+GpY3cJsU=
Message-ID: <84144f020810230658o7c6b3651k2d671aab09aa71fb@mail.gmail.com>
Date: Thu, 23 Oct 2008 16:58:53 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: SLUB defrag pull request?
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0810230638450.11924@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223883004.31587.15.camel@penberg-laptop>
	 <Pine.LNX.4.64.0810221315080.26671@quilx.com>
	 <E1KskHI-0002AF-Hz@pomaz-ex.szeredi.hu>
	 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221416130.26639@quilx.com>
	 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
	 <1224745831.25814.21.camel@penberg-laptop>
	 <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810230638450.11924@quilx.com>
X-Google-Sender-Auth: 4646e9f69bf85ff2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 4:40 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Solid? What is not solid? The SLUB design was made in part because of the
> defrag problems that were not easy to solve with SLAB. The ability to lock
> down a slab allows stabilizing objects. We discussed solutions to the
> fragmentation problem for years and did not get anywhere with SLAB.

I'd assume he's talking about the Intel-reported regression that's yet
to be resolved.
