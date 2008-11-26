Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbYKZUfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbYKZUfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYKZUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:35:04 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:18375 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKZUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:35:02 -0500
Date: Wed, 26 Nov 2008 21:34:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: jbarnes@virtuousgeek.org, greg@kroah.com, miltonm@bga.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: Re: [PATCH 1/2] PCI: allow pci driver to support only dynids
Message-ID: <20081126213445.2ba440c8@hyperion.delvare>
In-Reply-To: <20081126151940.GA16132@sequoia.sous-sol.org>
References: <20081126033610.GB19881@sequoia.sous-sol.org>
	<20081126092808.48519dcb@hyperion.delvare>
	<20081126151940.GA16132@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Wed, 26 Nov 2008 07:19:40 -0800, Chris Wright wrote:
> * Jean Delvare (khali@linux-fr.org) wrote:
> > As a side note, I am curious what PCI driver we do have which has
> > driver->probe defined but no driver->id_table. Did you hit an actual
> > issue or are you fixing a theoretical one?
> 
> Such a driver was patch 2/2.
> 
> http://lkml.org/lkml/2008/11/26/11
> 
> It's meant to have only dynamic ids, worked fine on 2.6.27 and oopsed
> from NULL id-> deref on current git.

Ah, OK, then your patch makes full sense and mine doesn't, sorry for
the noise. Feel free to add my Acked-by on your patch.

-- 
Jean Delvare
