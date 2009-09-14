Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbZINUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbZINUOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933759AbZINUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:14:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54148 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933631AbZINUI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 53/72] Blackfin: delete '-spi' suffix in ad1836/ad1938 driver name
Date: Mon, 14 Sep 2009 16:07:57 -0400
Message-Id: <1252958896-25150-54-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

The ASoC drivers have dropped the redundant "-spi" suffix in the driver
name, so update the board resources accordingly.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c     |    2 +-
 arch/blackfin/mach-bf533/boards/H8606.c     |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c  |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c     |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c     |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c  |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c    |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c     |    4 ++--
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c     |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c     |    2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index fdd518c..a0f623d 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -568,7 +568,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 4ab9cfa..2849b09 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -609,7 +609,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 30ff3c4..6c2b47f 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -231,7 +231,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 16,
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 7052568..ef31bc5 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -130,7 +130,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 88b2dfc..fd518e3 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -274,7 +274,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 3954baa..729fd7c 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -281,7 +281,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 159e5b2..220cfda 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -135,7 +135,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 0d93bbe..10b35b8 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -352,7 +352,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index d5aabee..7ce7d94 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -870,7 +870,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BF5XX_SOC_AD1836) \
 	|| defined(CONFIG_SND_BF5XX_SOC_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 4,/* CONFIG_SND_BLACKFIN_SPI_PFBIT */
@@ -881,7 +881,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BF5XX_SOC_AD1938) || defined(CONFIG_SND_BF5XX_SOC_AD1938_MODULE)
 	{
-		.modalias = "ad1938-spi",
+		.modalias = "ad1938",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 0,/* CONFIG_SND_BLACKFIN_SPI_PFBIT */
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 88eade8..dc4f161 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -135,7 +135,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 3c06010..e50d136 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -702,7 +702,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 1,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index cedcc3c..5721620 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -132,7 +132,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 10edc99..caed96b 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -345,7 +345,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) \
 	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
-		.modalias = "ad1836-spi",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-- 
1.6.4.2

