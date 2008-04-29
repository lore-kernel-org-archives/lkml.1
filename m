Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYD2MlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYD2MlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYD2Mk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:40:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:44633 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYD2Mk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MbkBO7b7qLAJ6+Ky37n4Q7eo8/CSgAE7+cbie1gcs38fgOrF2yrXeN1owd3QPknbPiX5uWLEZ0A3nr8mnsTZJSpy/PVwGej8MDjrQtPSz7CGjnInM+HBUM9NpQNTJjwI7o8OqDsQ70vmnvMmJXxB9pSeqTtxzYAfEKmYWGFh3xM=
Message-ID: <17896ec80804290540s492962a6ke0ab8790755337de@mail.gmail.com>
Date: Tue, 29 Apr 2008 14:40:54 +0200
From: "Mile Davidovic" <md4linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Network driver questions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
We have some dedicated interface for connecting various external
devices (NOR, ONENAND, SMSC network adapter), similar to PCI except
one big difference/restriction:
we can not work in atomic context because low lever drivers have such
limitation.

I would like to write network driver (for SMSC chip for example) with
this restriction.

Do we have some network driver which also have suffer from similar restrictions?

Thanks in advance
Mile
