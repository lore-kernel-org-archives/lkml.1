Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbZEOO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbZEOO5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZEOO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:57:39 -0400
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:54621 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZEOO5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:57:38 -0400
From: "Mukker, Atul" <Atul.Mukker@lsi.com>
To: Jeff Garzik <jeff@garzik.org>, Julian Calaby <julian.calaby@gmail.com>
CC: adam radford <aradford@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Fri, 15 May 2009 08:56:25 -0600
Subject: RE: [RFQ] New driver architecture questions
Thread-Topic: [RFQ] New driver architecture questions
Thread-Index: AcnVCYguckM1XJhxQOu5hjlIH97UfgAY0w7Q
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A96C7789@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
 	<4A0B858F.3080405@garzik.org>
 <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
 	<4A0B9B0D.6080006@garzik.org>
 <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
 <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
 <4A0CDB27.6090009@garzik.org>
In-Reply-To: <4A0CDB27.6090009@garzik.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
> >> Perhaps this is a bad example?  It seems like the "common layer"
> >> sections that are "cross-OS" shouldn't contain any Linux specific code
> at all.
> >
> > I think the implication is that the cross-OS parts are coded, as it
> > happens, in the linux coding style, using linux functions, but then a
> > Windows layer maps these to Windows specific functions.
> 
> Correct.
> 
> 	Jeff
> 
> 
> 
[Atul] I think we are close, for example, memcpy API in the stack is osi_memcpy(), which translates to memcpy() on Linux and ScsiPortMoveMemory() on windows.

