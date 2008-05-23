Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYEWRIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYEWRIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYEWRIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:08:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50126 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbYEWRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:08:46 -0400
Date: Fri, 23 May 2008 10:08:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] explicitly document overloaded page flags V2
In-Reply-To: <exportbomb.1211560342@pinky>
Message-ID: <Pine.LNX.4.64.0805231006100.1847@schroedinger.engr.sgi.com>
References: <exportbomb.1211560342@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

If we want to do the bit aliasing at the PG_xxx layer then there may be a 
way to simplify the page flag generation function because the xxx in 
PG_xxx is always the lower case of the PageXxx case. So we could remove 
one parameter if we can find some kind of cpp function that can lowercase 
a text.

