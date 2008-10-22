Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYJVQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYJVQ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYJVQ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:28:32 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:56037 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJVQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:28:32 -0400
Date: Wed, 22 Oct 2008 09:28:14 -0700 (PDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
In-Reply-To: <20081022161836.GG9639@localhost>
Message-ID: <Pine.LNX.4.64.0810220926130.7633@quilx.com>
References: <20081022161836.GG9639@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:

> Please check -- wouldn't it be better to use such a macro?

Looks good. But could you rename OO_MAX to something different? There is 
already s->max which may cause confusion because s->max is the maximum 
number of objects in a slab. OO_MAX is the maximum mask?

