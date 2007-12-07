Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbXLGTH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbXLGTH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 14:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXLGTHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 14:07:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbXLGTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 14:07:19 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com
Subject: [PATCH 0/3] Unify segment headers
Date: Fri,  7 Dec 2007 14:22:39 -0200
Message-Id: <119704456265-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this patch, I unify segment_32.h and segment_64.h into segment.h
They have some common parts, but a considerable ammount of code still has
to be around ifdefs. 

The only patch that is really important to paravirt is the first one, that
moves a paravirt definition into the common header. The other two are just
normal integration, and pretty much independent



