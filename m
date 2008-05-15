Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYEOR2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYEOR2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYEOR2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:28:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56750 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbYEOR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:28:00 -0400
Date: Thu, 15 May 2008 10:28:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-flags: record page flag overlays explicitly
In-Reply-To: <1210871989.0@pinky>
Message-ID: <Pine.LNX.4.64.0805151026410.18354@schroedinger.engr.sgi.com>
References: <exportbomb.1210871946@pinky> <1210871989.0@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Andy Whitcroft wrote:

> Now that we have a single enum to generate the bit orders it makes sense
> to express overlays in the same place.  So create per use aliases for
> this bit in the main page-flags enum and use those in the accessors.

Well I thought it would be better to have the overlays defined when the 
PAGEFLAGS_xx macro is used. If that is done then every PG_xxx has a unique 
id. The aliasing is then only through PageXXXX() using a PG_yyy
