Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYEVQvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYEVQvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYEVQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:51:01 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42102 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006AbYEVQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:51:00 -0400
Message-ID: <4835A3F1.8020701@cs.helsinki.fi>
Date: Thu, 22 May 2008 19:48:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: dhowells@redhat.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] nommu: fix ksize() abuse
References: <Pine.LNX.4.64.0805221909050.4056@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805220949370.27587@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805220949370.27587@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Does kobjsize exisst for !nommu?

No, it doesn't. The abusers here are #ifdef NOMMU, though.
