Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZCJR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZCJR4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZCJR4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:56:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16252 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZCJR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:56:06 -0400
Date: Tue, 10 Mar 2009 18:55:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 00/31] Add a lot of module alias statements
Message-ID: <20090310185558.072e6fc6@hyperion.delvare>
In-Reply-To: <1236707391.6339.3.camel@quest>
References: <cover.1236702228.git.scott@canonical.com>
	<20090310184624.4e28d18e@hyperion.delvare>
	<1236707391.6339.3.camel@quest>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 17:49:51 +0000, Scott James Remnant wrote:
> On Tue, 2009-03-10 at 18:46 +0100, Jean Delvare wrote:
> 
> > I don't get how it could make any difference in terms of performance.
> > As far as I know, all the module aliases that come from the kernel are
> > assembled into /lib/modules/$version/modules.alias when the kernel is
> > installed, and that file must be processed by modprobe the exact same
> > way another configuration file would. Or am I missing something?
>
> With current modprobe those files are turned into a binary index that
> can be read and processed *much* faster.

What would prevent the same binary index from being generated from
user-provided module aliases?

-- 
Jean Delvare
