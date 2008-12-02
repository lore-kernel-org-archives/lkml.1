Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYLBSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYLBSPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYLBSPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:15:37 -0500
Received: from mx2.netapp.com ([216.240.18.37]:39191 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbYLBSPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:15:36 -0500
X-IronPort-AV: E=Sophos;i="4.33,702,1220252400"; 
   d="scan'208";a="93527792"
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
 than 120 seconds"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-nfs@vger.kernel.org,
       Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <20081202162625.GM47559@fit.vutbr.cz>
References: <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
	 <1228091380.7112.17.camel@heimdal.trondhjem.org>
	 <20081202152256.GI47559@fit.vutbr.cz>
	 <1228232222.3090.5.camel@heimdal.trondhjem.org>
	 <20081202162625.GM47559@fit.vutbr.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 02 Dec 2008 13:10:07 -0500
Message-Id: <1228241407.3090.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 02 Dec 2008 18:11:07.0550 (UTC) FILETIME=[58F61BE0:01C954A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 17:26 +0100, Kasparek Tomas wrote:

> Did tried. The number should be seconds and defaults to 60, These
> connections are still there after several hours. Changing it to 10 (sec)
> and same behaviour. (BTW The server did not changed in last several months)

Are you seeing the same behaviour with 'netstat -t'?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
