Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXLMEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXLMEqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXLMEqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:46:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbXLMEqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:46:10 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com
Subject: [PATCH 0/19 - v3] desc_struct integration
Date: Thu, 13 Dec 2007 00:01:33 -0200
Message-Id: <11975113122984-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196957800568-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here it goes a new version of the patchset.

It addresses the problems raised, namely:
* it does not harm make headers_check anymore. (fill_ldt is moved to desc.h)
* it fixes the x86_64 spontaneous boot problem
* it does not have a warning at get_desc_base() anymore.



