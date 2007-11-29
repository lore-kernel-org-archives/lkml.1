Return-Path: <linux-kernel-owner+w=401wt.eu-S1762456AbXK2BSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762456AbXK2BSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbXK2BSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:18:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbXK2BSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:18:07 -0500
Date: Thu, 29 Nov 2007 02:18:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Message-ID: <20071129011802.GK24223@one.firstfloor.org>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 04:11:37PM -0800, Christoph Lameter wrote:
> 1. The stack canary

You would need to change gcc with a new option and only allow the stack
checking when the compiler supports the new option. However the problem
is still how to get a reasonable fixed offset. Or perhaps just change
gcc to use a linker symbol relative to %gs that could be set to anything?

-Andi
