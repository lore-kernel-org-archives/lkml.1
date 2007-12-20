Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXLTUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXLTUHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLTUHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:07:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbXLTUHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:07:00 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com
Subject: [PATCH 0/15] adjust pvops to accomodate its x86_64 variant
Date: Thu, 20 Dec 2007 18:03:55 -0200
Message-Id: <11981810504172-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

With this series, the bulk of the work of pvops64 is done.
Here, I integrate most of the paravirt.c and paravirt.h files, making
them applicable to both architectures.

CONFIG_PARAVIRT is _not_ present yet. Basically, this code is missing page
table integration (patches currently being worked on by Jeremy).

Enjoy


