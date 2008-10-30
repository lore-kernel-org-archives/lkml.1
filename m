Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYJ3QDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYJ3QDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYJ3QD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:03:26 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:52035 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYJ3QDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:03:25 -0400
Date: Thu, 30 Oct 2008 11:02:30 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] vmemmap: warn about page_structs with remote distance
In-Reply-To: <alpine.DEB.1.10.0810280312390.16242@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0810301100160.20953@quilx.com>
References: <alpine.DEB.1.10.0810280312390.16242@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, David Rientjes wrote:

> It's insufficient to simply compare node ids when warning about offnode
> page_structs since it's possible to still have local affinity.

Well that means that we distinguish nodes on the same motherboard (f.e. 
AMD memory architecture) from nodes that are on truly remote nodes.

Guess the delays on a single motherboard do not matter much?

Acked-by: Christoph Lameter <cl@linux-foundation.org>

