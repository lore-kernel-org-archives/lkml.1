Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbYCKX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbYCKX0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCKX0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:26:32 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:27440 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYCKX0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:26:31 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Terminate hugetlbfs mount argument list
X-Message-Flag: Warning: May contain useful information
References: <20080311224204.GA16719@basil.nowhere.org>
	<adabq5klvw1.fsf@cisco.com> <20080311225623.GE428@one.firstfloor.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 11 Mar 2008 16:26:00 -0700
In-Reply-To: <20080311225623.GE428@one.firstfloor.org> (Andi Kleen's message of "Tue, 11 Mar 2008 23:56:23 +0100")
Message-ID: <ada7ig8lu5z.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 23:26:00.0426 (UTC) FILETIME=[441CB4A0:01C883CF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hmm indeed I did. To my defense it's a weird unusual coding pattern
 > that tricked me.  What good is it to give terminator elements own enum values?

It's a little odd.  But I guess it does let you do

	token = match_token(...table...);
	switch (token) {
	case ERR_VALUE:...

and get ERR_VALUE back for anything that doesn't match one of the real
token patterns.

 - R.
