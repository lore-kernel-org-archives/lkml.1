Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXLLRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXLLRFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbXLLRE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:04:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXLLREy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:04:54 -0500
Date: Wed, 12 Dec 2007 12:04:40 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Klein <osstklei@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Michael Ellermann <michael@ellerman.id.au>,
       Michael Neuling <mikey@neuling.org>
Subject: Re: [RFC] ehea: kdump support using new shutdown hook
Message-ID: <20071212170440.GD2359@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Klein <osstklei@de.ibm.com>,
	Paul Mackerras <paulus@samba.org>,
	Christoph Raisch <raisch@de.ibm.com>,
	Jan-Bernd Themann <themann@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
	netdev <netdev@vger.kernel.org>,
	Stefan Roscher <stefan.roscher@de.ibm.com>,
	Michael Ellermann <michael@ellerman.id.au>,
	Michael Neuling <mikey@neuling.org>
References: <200712121753.43543.osstklei@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712121753.43543.osstklei@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 05:53:43PM +0100, Thomas Klein wrote:

 > +static void ehea_update_adapter_handles(struct ehea_adapter *adapter)
 > +{
 > +	int i, k;
 > +	int j = 0;
 > +
 > +	memset(adapter->res_handles, sizeof(adapter->res_handles), 0);

arguments wrong way around.
 
	Dave
 
-- 
http://www.codemonkey.org.uk
