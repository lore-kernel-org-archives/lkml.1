Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbXEaNlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbXEaNlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXEaNli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:41:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXEaNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:41:36 -0400
Date: Thu, 31 May 2007 14:41:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Klein <osstklei@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ehea: Receive SKB Aggregation
Message-ID: <20070531134118.GA30501@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Thomas Klein <osstklei@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
	Christoph Raisch <raisch@de.ibm.com>,
	Jan-Bernd Themann <ossthema@de.ibm.com>,
	Jan-Bernd Themann <themann@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
	netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
	Stefan Roscher <ossrosch@linux.vnet.ibm.com>
References: <200705311354.56979.osstklei@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705311354.56979.osstklei@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still very unhappy with having all this in various drivers.  There's
a lot of code that can be turned into generic library functions, and even
more code that could be made generic with some amount of refactoring.
