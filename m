Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbYEPAV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbYEPAV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYEPAVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:21:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47089 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYEPAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:21:49 -0400
Date: Fri, 16 May 2008 09:21:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 2/3] slub: record page flag overlays explicitly
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1210871999.0@pinky>
References: <exportbomb.1210871946@pinky> <1210871999.0@pinky>
Message-Id: <20080516092027.CDD2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SLUB reuses two page bits for internal purposes, it overlays PG_active
> and PG_error.  This is hidden away in slub.c.  Document these overlays
> explicitly in the main page-flags enum along with all the others.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Agreed.
I like your approach :)



