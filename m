Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXC0GsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXC0GsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965194AbXC0GsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:48:00 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:9827 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965095AbXC0Gr7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:47:59 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=rLqTiyOT9zAV8wM1GjTwPp2CkWaZDGEYXxk2xfZ0bQrgwOswAyd91FLiukh/fpf+IQClT1POk0U/gWvIRlteOQEDIFuXd2oXirwWF+w1E4WiM5S/eNMMiUwvY89uuAsq;
X-SBRSScore: None
X-IronPort-AV: i="4.14,331,1170630000"; 
   d="scan'208"; a="63223450:sNHT55825768"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH]: Fix bogus softlockup warning with sysrq-t
Date: Tue, 27 Mar 2007 08:47:48 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0501C20B@ABGEX01E.abg.fsc.net>
In-Reply-To: <4608AF01.4060804@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]: Fix bogus softlockup warning with sysrq-t
Thread-Index: AcdwMtOKZL417UqFS6qEyhpdDV9R0wACILyA
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com> <4608AF01.4060804@goop.org>
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Mar 2007 06:47:44.0964 (UTC) FILETIME=[D30E0040:01C7703B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I could easy add a "global disable" function, which would allow long
> sysrq messages, and it would help Thilo with his long flash update freezes.

A "global disable" and "reenable" functions pair which works during irq disabled,
would be a perfect solution for me. Thx Jeremy for your effort :)

Ciao Thilo
