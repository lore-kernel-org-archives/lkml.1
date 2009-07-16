Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbZGPPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbZGPPqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbZGPPqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:46:20 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:62719 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbZGPPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:46:19 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: regression post 2.6.30: device mapper fails on some logical volumes
Date: Thu, 16 Jul 2009 17:46:05 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-release; KDE/4.2.4; i686; ; )
Cc: Alasdair G Kergon <agk@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200907151852.15121.borntraeger@de.ibm.com> <200907160736.09885.borntraeger@de.ibm.com> <20090716144438.GA8257@redhat.com>
In-Reply-To: <20090716144438.GA8257@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907161746.06935.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 16 Juli 2009 16:44:39 schrieb Mike Snitzer:

I had another reproduce, and with the latest code (2.6.31-rc3) the mislignment  
warnings from rc1 are indeed gone: I now only have 

[    6.283482] device-mapper: table: 253:51: dasdf1 too small for target
[    6.283488] device-mapper: table: 253:51: dasde1 too small for target
[    6.648895] device-mapper: table: 253:64: dasdc1 too small for target
[    6.648900] device-mapper: table: 253:64: dasdd1 too small for target

The logical volumes space-test and space-home still dont appear.

Christian
