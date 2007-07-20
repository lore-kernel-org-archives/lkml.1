Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbXGTKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbXGTKlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXGTKll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:41:41 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:63963 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXGTKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GrRxEpvfhgNUwd/1lNGU5pUdwej+RNCCL+WqEDtklijBY5rCR0XgHgakbYqxF9mEThDJnBkDh5Vnu2Ipl78iwcljqlX3ZONEppXWaohjQikLhZuFTkk+RnkwKWCSK08YATjmh7sw1OiqIDqoEmL3q9shqRllTfzeHjXMpZdLe74=
Message-ID: <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>
Date: Fri, 20 Jul 2007 16:11:38 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20070531003012.302019683@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070531002047.702473071@sgi.com>
	 <20070531003012.302019683@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Just cleaning up my inbox, and stumbled across this thread ... ]


On 5/31/07, clameter@sgi.com <clameter@sgi.com> wrote:
> Introduce CONFIG_STABLE to control checks only useful for development.
>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> [...]
>  menu "General setup"
>
> +config STABLE
> +       bool "Stable kernel"
> +       help
> +         If the kernel is configured to be a stable kernel then various
> +         checks that are only of interest to kernel development will be
> +         omitted.
> +


"A programmer who uses assertions during testing and turns them off
during production is like a sailor who wears a life vest while drilling
on shore and takes it off at sea."
                                                - Tony Hoare


Probably you meant to turn off debug _output_ (and not _checks_)
with this config option? But we already have CONFIG_FOO_DEBUG_BAR
for those situations ...

Satyam
