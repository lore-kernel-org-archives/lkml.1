Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbXGMS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbXGMS5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761906AbXGMS5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:57:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44168 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761866AbXGMS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:57:05 -0400
In-Reply-To: <adahco943ip.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF419657E7.3098466C-ON87257317.0067BBE6-88257317.0067EA65@us.ibm.com>
From: Shirley Ma <xma@us.ibm.com>
Date: Fri, 13 Jul 2007 11:56:57 -0700
X-MIMETrack: Serialize by Router on D03MC012/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 07/13/2007 12:57:00,
	Serialize complete at 07/13/2007 12:57:00
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,

        FYI, we are working on several IPoIB performance improvement 
patches which are not on the list. Some of the patches are under test, 
some of the patches are going to be submitted soon. They are:

1.  skb aggregations for both dev xmit(networking layer) and IPoIB send 
(it will be submitted soon, for both UD and RC mode)
2.  multiple interrupt vectors in IPoIB for multiple links scalability 
(working on patch for both UD and RC mode)
3.  split CQ and send completion aggregation (for both UD and RC mode)
4.  LRO for IPoIB when generic LRO is available in networking layer. (UD 
mode only)

        Some of them might be made in 2.6.23 timeline, some of them might 
not, it depends on our test progress and community review feedback.

Thanks
Shirley
