Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZBWQTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZBWQTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBWQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:19:22 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59114 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbZBWQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:19:21 -0500
Date: Mon, 23 Feb 2009 11:11:06 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add min_partial sysfs tunable
In-Reply-To: <1235384784.6216.34.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902231110190.22276@qirst.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>  <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com>  <1235377162.6216.5.camel@penberg-laptop>  <alpine.DEB.2.00.0902230126080.19494@chino.kir.corp.google.com>
 <1235384784.6216.34.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note also that the min_partial is something useful to reduce the page
allocator overhead. If we can get the page allocator faster then the
min_partial defaults can be reduced.

