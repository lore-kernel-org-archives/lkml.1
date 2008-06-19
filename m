Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYFSXwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYFSXwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYFSXwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:52:45 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:20132 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751995AbYFSXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:52:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ldnDG/ruVU5efHGN6W+yWsUBadJas+Kgpn9SfY94RHKJkz26QUcV2YWStim2r172lgYpLfpWdfvidf7lqvYr5QW/AhFI1YuzoqiQWCYxMeDd/o5qmn3zAfuiJFXqdO5Wy4RzARwFHkO1pzr2HFUu7du211sExkAjCyYpl0vP/ag=  ;
X-YMail-OSG: ivFxZRkVM1mMNkbvYF2RrhQTKu7lSDBwlo9Z0Vy6VUPgU0c.kPomGxnFvr8Y8Ghi2qrK522D0.2M9z8lVIWmoAaHDOWHJzAzWPktC5rNq7nGck_Anhzpr4pql1cCzDYZJ8g-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kernel-doc: handle/strip __init
Date: Thu, 19 Jun 2008 16:52:42 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>
References: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
In-Reply-To: <20080619160329.1a4fe917.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806191652.42717.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008, Randy Dunlap wrote:
> Handle __init in functions with kernel-doc notation by stripping the
> __init away from the output doc.  This is already being done for
> "__devinit".  

Right.  Shouldn't this also be done for __exit and __devexit too?
