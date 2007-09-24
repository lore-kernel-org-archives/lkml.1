Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXIXVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXIXVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXIXVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:16:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33129 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718AbXIXVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:16:22 -0400
Date: Mon, 24 Sep 2007 14:16:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] LBS: fix uninitialized swapper_space
In-Reply-To: <Pine.LNX.4.64.0709212144210.13529@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709241414270.30982@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0709212144210.13529@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Hugh Dickins wrote:

> Swapping crashed immediately: must initialize new fields of swapper_space.

Thanks for finding that. It may be better though to use the new
mapping_setup() function instead? That way there is no #ifdef.
