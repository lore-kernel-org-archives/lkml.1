Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYC0Ld1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYC0Ld1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYC0LdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:33:13 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757390AbYC0LdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:33:12 -0400
Date: Thu, 27 Mar 2008 06:33:07 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
 setup_data
Message-Id: <20080327063307.ac323913.pj@sgi.com>
In-Reply-To: <1206601748.3067.22.camel@caritas-dev.intel.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
+/* setup data types */
+#define SETUP_NONE			0
+
+/* extensible setup data list node */
+struct setup_data {
+	u64 next;
+	u32 type;
+	u32 len;
+	u8 data[0];
+};


I don't understand what purpose the 'type' field serves.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
