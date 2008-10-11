Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYJKNaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYJKNaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYJKNaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:30:10 -0400
Received: from web38204.mail.mud.yahoo.com ([209.191.124.147]:25691 "HELO
	web38204.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752744AbYJKNaJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:30:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qyJSm/lMvYc9uJCov1T2JOJIEKfIjyBc7bohY9VrfnZgqeMuxT+7OJB4YPg2QaeTXI+W4p/nD5cuUHJEPhLEjll+CesxkYDfP+gPbNrOxrrd2OJyHr7YRvbcBCn6l5+kfDcoa8YfE6dF6pyRG4bqK+nrEtQwuV0I1Ve2973f1dY=;
X-YMail-OSG: 0jjILHsVM1nRNtuNJKVOUmeqoYtjKAvACvSGQmQu32DriXZLFWLIR4.2AHOi2_vSApFsbDTxCNhPPurSi8gXk6TL2HzqwufUvPDRb3crVAopVTn3tdh5radoPUzAT8CMPxngcS3ccGgVspkezZgrDzwff_1hlsLTv_t_WguhoiLKkA--
X-Mailer: YahooMailRC/1096.40 YahooMailWebService/0.7.218.2
Date: Sat, 11 Oct 2008 06:30:08 -0700 (PDT)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Help text for config OPTIMIZE_INLINING
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <537458.72510.qm@web38204.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main help text for the OPTIMIZE_INLINING kconfig option says:
"The gcc 4.x series have a rewritten inlining algorithm and disabling this option will generate a smaller kernel there."

That suggests that to generate a smaller kernel one should set the option to n. However the short text says:
"Allow gcc to uninline functions marked 'inline'"

While suggests that one should set it to y to generate smaller kernels. My own experience says that setting it to y DOES generate a smaller kernel so perhaps the main text should be changed to reflect this?


 Sitsofe | http://sucs.org/~sits/



      
