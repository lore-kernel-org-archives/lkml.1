Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbXFHTD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbXFHTD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbXFHTDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:03:49 -0400
Received: from relais.videotron.ca ([24.201.245.36]:42227 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXFHTDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:03:48 -0400
Date: Fri, 08 Jun 2007 15:03:42 -0400
From: Mike Schmidt <mike@intello.com>
Subject: How does dummy network driver get its mac addresses?
To: linux-kernel@vger.kernel.org
Message-id: <4669A80E.1050102@intello.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_gnCrszOfMB9pKGR72iF9MA)"
X-Greylist: Sender succeeded SMTP AUTH authentication,
 not delayed by milter-greylist-3.0 (deepspace.sepia.com [205.236.40.42]); Fri,
 08 Jun 2007 14:58:55 -0400 (EDT)
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_gnCrszOfMB9pKGR72iF9MA)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

please cc me directly with any responses - I am not (yet) a member of this mailing list.

I just created 99 dummy network devices, and they all had different, random-looking addresses. I recently searched though all the IANA/IEEE documentation looking for a mechanism or policy to select local, virtual mac addresses that could not interfere with real ones. But there seems to be no clear concensus. Even the use of the 'local' bit seems to be inconsistent, I saw registered OUIs in the AA:... (from memory) range, for example. 

I noticed that all the mac addresses assigned by the dummy driver have the 'local' bit set. For those who are wondering, that's the second least significant bit  in the first digit of the mac address: so all addresses that start with x2, x3, x6, x7, xA, xB, and xE, xF are 'local'. The last bit is the multicast bit.

In the 2.4 kernels, these devices all received a 00:00:00... mac address, although this is declared incorrect in the RFCs I read. So, I was making my own, somewhat arbitrarily. In 2.6, this seems to be solved. Can anyone tell me what the algorithm/criteria are that allow the 2.6 kernels to set up random mac addresses without conflicting with real devices?

I have searched the mailing list, but it's pretty hard to select for this kind of information. 

Thanks very much. This is a great mailing list. It's been very responsive to me so far. I thank you all. 

Mike





--Boundary_(ID_gnCrszOfMB9pKGR72iF9MA)
Content-type: text/x-vcard; charset=utf-8; name=mike.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=mike.vcf

begin:vcard
fn:Mike Schmidt
n:Schmidt;Mike
org:Intello Technologies Inc. 
adr;quoted-printable;quoted-printable:;;580 1=C3=A8re Rue;Saint-Jean-sur-Richelieu;Qu=C3=A9;J2X 3B4;Canada
email;internet:mike@intello.com
title:Vice-President
tel;work:450-358-2266 x223
tel;cell:514-835-9497
x-mozilla-html:FALSE
url:http://www.intello.com
version:2.1
end:vcard


--Boundary_(ID_gnCrszOfMB9pKGR72iF9MA)--
