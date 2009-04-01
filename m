Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZDAWd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZDAWd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZDAWdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:33:46 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:53600 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbZDAWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:33:45 -0400
From: Frans Pop <elendil@planet.nl>
To: maximilian attems <max@stro.at>
Subject: Re: [PATCH 4/5] deb-pkg: allow to specify a custom revision for .deb packages
Date: Thu, 2 Apr 2009 00:33:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <200904012143.36217.elendil@planet.nl> <20090401214434.GE17518@stro.at>
In-Reply-To: <20090401214434.GE17518@stro.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904020033.04264.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2009 22:33:43.0538 (UTC) FILETIME=[E9D51520:01C9B319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009, maximilian attems wrote:
> On Wed, 01 Apr 2009, Frans Pop wrote:
> > Allow to specify a custom revision for the generated .deb by
> > exporting the environment variable KDEB_PKGVERSION.
>
> nack
> looks like double work circumventling .localversion

No. .localversion gets added to the _kernel_ version in the package name.
This is to overrule the standard _package_ version.

I use it for example to automatically create a series of versioned 
packages during bisection based on .git/BISECT_LOG:
linux-2.6.29_1_amd64.deb
linux-2.6.29_2_amd64.deb
linux-2.6.29_3_amd64.deb
linux-2.6.29_4_amd64.deb
...

For "normal" packages I use package versions based on 'git describe'.
