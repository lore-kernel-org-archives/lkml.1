Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYB0RZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYB0RZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYB0RZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:25:14 -0500
Received: from mx.bridgeco.net ([213.173.191.47]:3381 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYB0RZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:25:13 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] [resend]The kernel gets no IP from some DHCP servers, 2.6.24
Date: Wed, 27 Feb 2008 18:25:10 +0100
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301C5CE6D@zuerich.BC-Int.NET>
In-Reply-To: <20080227083819.70ddb374@extreme>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [resend]The kernel gets no IP from some DHCP servers, 2.6.24
Thread-Index: Ach5X0JoVdjXu9V4Rj2dEai1T/Ky8gABLIGw
References: <83116F0A4FF67A4F97BA0B6E408C48E301C5CDEF@zuerich.BC-Int.NET><47C55BBF.7080501@trash.net><83116F0A4FF67A4F97BA0B6E408C48E301C5CE08@zuerich.BC-Int.NET> <20080227083819.70ddb374@extreme>
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "Patrick McHardy" <kaber@trash.net>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>, <davem@davemloft.net>, <ebiederman@lnxi.com>
X-OriginalArrivalTime: 27 Feb 2008 17:25:14.0823 (UTC) FILETIME=[B6F50D70:01C87965]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
>> In my opinion it is necessary to distinguish between INADDR_ANY and 
>> the ZERO address which ist requested to be in the DHCPDISCOVER packet.
>Just delete the lines and the address will be zero because of earlier memset().

>From my personal point of view it is important to document the requirement of the
two addresses to be 0.0.0.0 either through the code itself or through a comment
which states clear the side effect of memset'ting the structure. 

Both roads lead to Rome :-)

Marcel
--
Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
