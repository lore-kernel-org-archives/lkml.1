Return-Path: <linux-kernel-owner+w=401wt.eu-S1765502AbYEVXqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765502AbYEVXqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbYEVXp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:45:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35929 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759035AbYEVXp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:45:57 -0400
Date: Thu, 22 May 2008 16:45:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mundt <lethal@linux-sh.org>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, dhowells@redhat.com,
       mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080522234036.GA18434@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0805221644470.30217@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
 <20080522234036.GA18434@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Paul Mundt wrote:

> Is ksize() happy with taking the head page instead of virt_to_page(objp)?

ksize() takes a pointer to an object. ksize() cannot take a the pointer to 
a page struct.


