Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZJMFPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZJMFPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZJMFPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:15:06 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2128 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZJMFPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:15:05 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Michael Chan" <mchan@broadcom.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Shmulik Ravid - Rabinovitz" <shmulikr@broadcom.com>
Date: Mon, 12 Oct 2009 22:14:22 -0700
Subject: Re: linux-next: net tree build failure
Thread-Topic: linux-next: net tree build failure
Thread-Index: AcpLvlCDzeCfAUbfRWW/kX1UJXSgKQADarWQ
Message-ID: <C27F8246C663564A84BB7AB34397724217C978403F@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20091013153308.af56910a.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66CAD3245KG17372666-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:

> Hi Dave,
>
> Today's linux-next build (powerpc allyesconfig) failed like this:
>
> drivers/net/cnic.c: In function 'cnic_init_storm_conn_bufs':
> drivers/net/cnic.c:1757: error: implicit declaration of functi
> on 'csum_ipv6_magic'
>
> Caused by commit 71034ba845c9ff219373066f904286c0b7506922 ("cnic: Add
> main functions to support bnx2x devices") which I have
> reverted for today.
>

I think adding #include <net/ip6_checksum.h> will work.  Will send a
patch right away.  Thanks.

