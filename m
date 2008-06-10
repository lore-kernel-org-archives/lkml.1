Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYFJWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYFJWWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbYFJWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:21:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38981 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbYFJWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:21:57 -0400
Message-ID: <484EFE82.6080003@garzik.org>
Date: Tue, 10 Jun 2008 18:21:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, hering2@de.ibm.com
Subject: Re: [PATCH][2.6.26] ehea: set mac address fix
References: <200806091617.38396.ossthema@de.ibm.com>
In-Reply-To: <200806091617.38396.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> eHEA has to call firmware functions in order to change the mac address
> of a logical port. This patch checks if the logical port is up
> when calling the register / deregister mac address calls. If the port
> is down these firmware calls would fail and are therefore not executed.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

applied


