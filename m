Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYKSTWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYKSTWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKSTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:22:43 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:42194 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYKSTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:22:43 -0500
Date: Wed, 19 Nov 2008 13:22:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak via slub kmem_cache_create
In-Reply-To: <1227111954.27162.28.camel@pc1117.cambridge.arm.com>
Message-ID: <Pine.LNX.4.64.0811191319360.23084@quilx.com>
References: <1227111954.27162.28.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proto_register could add another field somewhere and store the pointer to
the name there? Then free the string on proto_unregister.

