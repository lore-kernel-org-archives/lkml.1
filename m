Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXJ3LQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXJ3LQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXJ3LQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:16:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:8669 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXJ3LQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hsBD2CDWfeA7Av7QYwydjbAzj23im2QAZxZLjFl+OaARNhRbaFGh2aPJCSwbC/BjGtEWUWOwf70dExvMDTUlUHGdiJ77RJg28IOv9qPeEYlD/CnYOhSWxBJdpgxbkmX12Ekpe7QdRcg5IrPg4VOVDijG4VtddHz6+qKNinZmf8E=
Message-ID: <252f133e0710300416x7490aeq4f371550fdf59b92@mail.gmail.com>
Date: Tue, 30 Oct 2007 07:16:20 -0400
From: "=?ISO-8859-1?Q?Bj=F6rn?=" <askadar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Huge performance regression in 2.6.23?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Have a look at slides 17, 18, and 19 of the presentation available at
http://people.freebsd.org/~kris/scaling/7.0%20Preview.pdf . It shows a
huge drop in performance for both PostgreSQL and MySQL under 2.6.23.

The slides are light on details on the exact setup, but I find it hard
to believe that such a major regression would have gone unnoticed
during testing of CFS. Maybe someone (with the appropriate hardware,
which I lack) can try to reproduce the results?

Is it really that bad?

- Bjoern
