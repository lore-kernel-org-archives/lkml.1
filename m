Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbXHXRpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbXHXRpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXHXRpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:45:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60696 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXHXRpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:45:22 -0400
In-Reply-To: <20070824165110.GH4282@austin.ibm.com>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: akepner@sgi.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus@ozlabs.org,
       Eder <meder@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       netdev-owner@vger.kernel.org, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>
MIME-Version: 1.0
Subject: Re: RFC: issues concerning the next NAPI interface
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OFB48299BB.9D9BCE91-ON87257341.006139E9-88257341.00614EB7@us.ibm.com>
From: Shirley Ma <xma@us.ibm.com>
Date: Fri, 24 Aug 2007 10:45:17 -0700
X-MIMETrack: Serialize by Router on D03MC012/03/M/IBM(Release 7.0.2HF32 | October 17, 2006) at
 08/24/2007 11:45:20,
	Serialize complete at 08/24/2007 11:45:20
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to be clear, in the previous email I posted on this thread, I
> described a worst-case network ping-pong test case (send a packet, wait
> for reply), and found out that a deffered interrupt scheme just damaged
> the performance of the test case. 

When splitting rx and tx handler, I found some performance gain by 
deffering interrupt scheme in tx not rx in IPoIB driver.

Shirley
