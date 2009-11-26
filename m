Return-Path: <linux-kernel-owner+w=401wt.eu-S932945AbZKZQ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbZKZQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685AbZKZQ2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:28:02 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55064 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbZKZQ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:28:01 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v0 2/3] res_counter: implement thresholds
Date: Thu, 26 Nov 2009 18:27:37 +0200
Message-Id: <8524ba285f6dd59cda939c28da523f344cdab3da.1259248846.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
 <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259248846.git.kirill@shutemov.name>
In-Reply-To: <cover.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows to setup two thresholds: one above current usage and one
below. Callback threshold_notifier() will be called if a threshold is
crossed.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
1.6.5.3

